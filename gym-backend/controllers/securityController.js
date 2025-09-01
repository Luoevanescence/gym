const mysql = require('mysql2/promise');
const { v4: uuidv4 } = require('uuid');
const dbConfig = require('../config/db');
const { toCamelCase } = require('../utils/caseConvert');

/**
 * 提交设备维修信息
 * POST /api/security/submit
 */
exports.submitRepairRequest = async (req, res) => {
  const { deviceId, eventType = '设备故障', imageUrl = '', remarks = '', userName = '匿名用户' } = req.body;

  if (!deviceId || !remarks) {
    return res.status(400).json({ success: false, message: '缺少 deviceId 或 remarks 参数' });
  }

  try {
    const connection = await mysql.createConnection(dbConfig);

    await connection.execute(`
      INSERT INTO security_monitoring (
        device_id, event_type, image_url, handled_by, remarks, created_at, status
      ) VALUES (?, ?, ?, ?, ?, NOW(), 0)
    `, [deviceId, eventType, imageUrl, userName, remarks]);

    await connection.end();
    res.json({ success: true, message: '维修申请已提交' });
  } catch (err) {
    console.error('提交维修申请失败:', err);
    res.status(500).json({ success: false, message: '服务器错误' });
  }
};

/**
 * 获取设备维修记录
 * GET /api/security/list?deviceId=xxx
 */
exports.getRepairRecords = async (req, res) => {
  const { deviceId } = req.query;

  try {
    const connection = await mysql.createConnection(dbConfig);
    const [rows] = await connection.execute(`
      SELECT monitor_id, device_id, event_type, image_url, handled_by, remarks, created_at, status
      FROM security_monitoring
      ${deviceId ? 'WHERE device_id = ?' : ''}
      ORDER BY created_at DESC
    `, deviceId ? [deviceId] : []);

    await connection.end();
    res.json({ success: true, data: rows.map(toCamelCase) });
  } catch (err) {
    console.error('获取维修记录失败:', err);
    res.status(500).json({ success: false, message: '服务器错误' });
  }
};
