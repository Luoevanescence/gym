const { v4: uuidv4 } = require('uuid');
const mysql = require('mysql2/promise');
const dbConfig = require('../config/db');
const { toCamelCase } = require('../utils/caseConvert');

exports.scanOpenDoor = async (req, res) => {
  const { userId, deviceId } = req.body;

  if (!userId || !deviceId) {
    return res.status(400).json({ success: false, message: '缺少 userId 或 deviceId' });
  }

  try {
    const connection = await mysql.createConnection(dbConfig);

    // 1. 校验设备是否存在且在线
    const [devices] = await connection.execute(
      `SELECT * FROM access_devices WHERE device_id = ? AND status = 'online'`,
      [deviceId]
    );
    if (devices.length === 0) {
      await connection.end();
      return res.status(404).json({ success: false, message: '设备不存在或不在线' });
    }

    // 2. 校验用户是否拥有有效会员卡（只校验支付状态）
    const [validCards] = await connection.execute(
      `SELECT * FROM payment_orders WHERE user_id = ? AND payment_status = 'paid'`,
      [userId]
    );
    if (validCards.length === 0) {
      await connection.end();
      return res.status(403).json({ success: false, message: '无有效会员卡，禁止通行' });
    }

    // 3. 获取最近一条进出记录
    const [lastRecord] = await connection.execute(
      `SELECT access_type FROM access_records WHERE user_id = ? ORDER BY access_time DESC LIMIT 1`,
      [userId]
    );

    let accessType = 'entry'; // 默认首次扫码为 entry
    if (lastRecord.length > 0 && lastRecord[0].access_type === 'entry') {
      accessType = 'exit';
    }

    // 4. 插入 access_records 记录
    const recordId = uuidv4();
    const now = new Date();

    await connection.execute(`
      INSERT INTO access_records (
        record_id, user_id, device_id, access_type, access_time, access_method
      ) VALUES (?, ?, ?, ?, ?, ?)
    `, [
      recordId, userId, deviceId, accessType, now, 'qr_code'
    ]);

    await connection.end();

    res.json({
      success: true,
      message: `开门成功，已记录${accessType === 'entry' ? '入场' : '出场'}`,
      accessType
    });

    // 可选：MQTT 或 TCP 通知硬件开门

  } catch (err) {
    console.error('扫码开门失败:', err);
    res.status(500).json({ success: false, message: '服务器错误' });
  }
};

exports.getAccessRecordsByUserId = async (req, res) => {
  const { userId } = req.query;

  if (!userId) {
    return res.status(400).json({ success: false, message: '缺少 userId 参数' });
  }

  try {
    const connection = await mysql.createConnection(dbConfig);
    const [rows] = await connection.execute(`
      SELECT 
        r.record_id,
        r.access_time,
        r.access_type,
        r.access_method,
        r.temperature,
        d.device_name,
        d.location
      FROM access_records r
      LEFT JOIN access_devices d ON r.device_id = d.device_id
      WHERE r.user_id = ?
      ORDER BY r.access_time DESC
    `, [userId]);
    await connection.end();

    const result = rows.map(toCamelCase);
    res.json({ success: true, data: result });
  } catch (err) {
    console.error('获取进出记录失败:', err);
    res.status(500).json({ success: false, message: '服务器错误' });
  }
};
