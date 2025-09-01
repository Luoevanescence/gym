// controllers/payController.js
const { v4: uuidv4 } = require('uuid');
const mysql = require('mysql2/promise');
const dbConfig = require('../config/db');
const { toCamelCase } = require('../utils/caseConvert');
exports.createOrder = async (req, res) => {
  const {
    userId,
    amount,
    membershipTypeId,
    paymentMethod = 'wechat',
    orderDescription = '购买会员卡'
  } = req.body;

  const orderId = uuidv4();
  const orderNumber = 'ORD' + Date.now();
  const transactionId = 'TXN' + Date.now();
  const paymentTime = new Date();

  try {
    const connection = await mysql.createConnection(dbConfig);

    // 1. 插入订单记录
    await connection.execute(`
      INSERT INTO payment_orders (
        order_id, user_id, order_number, amount, payment_method, payment_status,
        transaction_id, payment_time, order_description, membership_type_id
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    `, [
      orderId, userId, orderNumber, amount, paymentMethod, 'paid',
      transactionId, paymentTime, orderDescription, membershipTypeId
    ]);

    // 2. 累加积分（amount 向下取整，转成整数）
    const pointsToAdd = Math.floor(Number(amount)); // 可按需保留小数
    await connection.execute(
      `UPDATE users SET points = points + ? WHERE user_id = ?`,
      [pointsToAdd, userId]
    );

    await connection.end();

    // 3. 返回结果
    res.json({
      success: true,
      data: { orderId, orderNumber, amount, paymentTime, addedPoints: pointsToAdd }
    });
  } catch (err) {
    console.error('创建订单失败:', err);
    res.status(500).json({ success: false, message: '服务器错误' });
  }
};

// 获取用户订单列表
exports.getOrdersByUserId = async (req, res) => {
  const { userId } = req.query;

  if (!userId) {
    return res.status(400).json({ success: false, message: '缺少 userId 参数' });
  }

  try {
    const connection = await mysql.createConnection(dbConfig);

    const [orders] = await connection.execute(`
      SELECT 
        p.order_id,
        p.amount,
        p.payment_time,
        p.order_description,
        p.membership_type_id,
        p.payment_status,
        t.type_name AS card_type,
        t.duration_days
      FROM payment_orders p
      LEFT JOIN membership_types t ON p.membership_type_id = t.type_id
      WHERE p.user_id = ?
      ORDER BY p.payment_time DESC
    `, [userId]);

    await connection.end();

    const result = orders.map(toCamelCase);

    res.json({ success: true, data: result });
  } catch (err) {
    console.error('获取订单失败:', err);
    res.status(500).json({ success: false, message: '服务器错误' });
  }
};

