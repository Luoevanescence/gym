const mysql = require('mysql2/promise');
const axios = require('axios');
const jwt = require('jsonwebtoken');
const { v4: uuidv4 } = require('uuid');
const dbConfig = require('../config/db');
const { toCamelCase } = require('../utils/caseConvert');
require('dotenv').config();

exports.wxLogin = async (req, res) => {
  const { code, avatarUrl, nickname } = req.body;
  console.log('前端参数:', code, avatarUrl, nickname);

  try {
    // 请求微信接口获取 openid
    const wxRes = await axios.get(
      `https://api.weixin.qq.com/sns/jscode2session?appid=${process.env.WX_APPID}&secret=${process.env.WX_SECRET}&js_code=${code}&grant_type=authorization_code`
    );
    const { openid } = wxRes.data;

    if (!openid) {
      return res.status(400).json({
        success: false,
        message: '获取 openid 失败'
      });
    }

    const connection = await mysql.createConnection(dbConfig);

    // 查询用户是否已存在
    const [users] = await connection.execute(
      'SELECT * FROM users WHERE wechat_openid = ?',
      [openid]
    );

    let user;

    if (users.length === 0) {
      // 用户不存在则插入新记录
      const userId = uuidv4();
      await connection.execute(
        `INSERT INTO users (user_id, wechat_openid, name, avatar_url, points, created_at)
         VALUES (?, ?, ?, ?, 0, NOW())`,
        [userId, openid, nickname, avatarUrl]
      );

      const [newUser] = await connection.execute(
        'SELECT * FROM users WHERE wechat_openid = ?',
        [openid]
      );

      user = newUser[0];
    } else {
      user = users[0];
    }

    // 查询该用户拥有的会员卡数量
    const [countResult] = await connection.execute(
      `SELECT COUNT(*) AS cardCount
       FROM payment_orders
       WHERE user_id = ? AND payment_status = 'paid'`,
      [user.user_id]
    );

    const cardCount = countResult[0]?.cardCount || 0;

    await connection.end();

    // 生成 token
    const token = jwt.sign(
      {
        userId: user.user_id,
        openid
      },
      process.env.JWT_SECRET,
      { expiresIn: '7d' }
    );

    // 返回响应
    res.json({
      success: true,
      token,
      user: {
        ...toCamelCase(user),
        cardCount,
        points: user.points || 0 // 返回积分
      }
    });
  } catch (err) {
    console.error('微信登录错误:', err);
    res.status(500).json({
      success: false,
      message: '服务器内部错误',
      error: err.message
    });
  }
};

exports.getUserInfo = async (req, res) => {
  const userId = req.params.userId;

  if (!userId) {
    return res.status(400).json({ success: false, message: '缺少 userId' });
  }

  try {
    const connection = await mysql.createConnection(dbConfig);

    // 查询用户基本信息
    const [userRows] = await connection.execute(`SELECT * FROM users WHERE user_id = ?`, [userId]);
    if (userRows.length === 0) {
      await connection.end();
      return res.status(404).json({ success: false, message: '用户不存在' });
    }

    const user = userRows[0];

    // 查询会员卡数量
    const [countRows] = await connection.execute(`
      SELECT COUNT(*) AS cardCount
      FROM payment_orders
      WHERE user_id = ? AND payment_status = 'paid'
    `, [userId]);

    const cardCount = countRows[0]?.cardCount || 0;

    await connection.end();

    res.json({
      success: true,
      data: {
        ...toCamelCase(user),
        cardCount,
        points: user.points || 0
      }
    });
  } catch (err) {
    console.error('获取用户信息失败:', err);
    res.status(500).json({ success: false, message: '服务器错误' });
  }
};



exports.updateUser = async (req, res) => {
  let {
    userId,
    name = null,
    phone = null,
    gender = null,
    birth = null,
    height = null,
    weight = null,
    avatarUrl = null
  } = req.body;

  if (!userId) {
    return res.status(400).json({
      success: false,
      message: '缺少 userId'
    });
  }

  try {
    const connection = await mysql.createConnection(dbConfig);
    await connection.execute(
      `UPDATE users SET
        name = ?,
        phone = ?,
        gender = ?,
        birthday = ?,
        height = ?,
        weight = ?,
        avatar_url = ?,
        updated_at = NOW()
      WHERE user_id = ?`,
      [name, phone, gender, birth, height, weight, avatarUrl, userId]
    );
    await connection.end();

    res.json({ success: true, message: '用户信息已更新' });
  } catch (err) {
    console.error('更新用户信息失败:', err);
    res.status(500).json({
      success: false,
      message: '服务器错误',
      error: err.message
    });
  }
};

