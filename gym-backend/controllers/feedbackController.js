const { v4: uuidv4 } = require('uuid');
const mysql = require('mysql2/promise');
const dbConfig = require('../config/db');
const { toCamelCase } = require('../utils/caseConvert');

// 提交一条用户反馈
exports.submitUserFeedback = async (req, res) => {
  const { userId, feedbackType, content, images, contactPhone } = req.body;

  if (!userId || !feedbackType || !content) {
    return res.status(400).json({ success: false, message: '缺少必要字段（userId、feedbackType、content）' });
  }

  try {
    const connection = await mysql.createConnection(dbConfig);
    const now = new Date();

    await connection.execute(`
      INSERT INTO user_feedbacks (
        user_id, feedback_type, content, images, contact_phone, status, created_at, updated_at
      ) VALUES (?, ?, ?, ?, ?, '未处理', ?, ?)
    `, [userId, feedbackType, content, images || '', contactPhone || '', now, now]);

    await connection.end();

    res.json({ success: true, message: '反馈提交成功' });
  } catch (err) {
    console.error('提交反馈失败:', err);
    res.status(500).json({ success: false, message: '服务器错误' });
  }
};

// 获取某用户的所有反馈记录
exports.getUserFeedbacks = async (req, res) => {
  const { userId } = req.query;

  if (!userId) {
    return res.status(400).json({ success: false, message: '缺少 userId 参数' });
  }

  try {
    const connection = await mysql.createConnection(dbConfig);
    const [rows] = await connection.execute(`
      SELECT 
        feedback_id,
        user_id,
        feedback_type,
        content,
        images,
        contact_phone,
        status,
        response,
        created_at,
        updated_at
      FROM user_feedbacks
      WHERE user_id = ?
      ORDER BY created_at DESC
    `, [userId]);
    await connection.end();

    const result = rows.map(toCamelCase);
    res.json({ success: true, data: result });
  } catch (err) {
    console.error('获取用户反馈失败:', err);
    res.status(500).json({ success: false, message: '服务器错误' });
  }
};
