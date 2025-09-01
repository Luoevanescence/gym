const mysql = require('mysql2/promise');
const dbConfig = require('../config/db');
const { toCamelCase } = require('../utils/caseConvert');
//获取全部会员卡类型
exports.getAllCardTypes = async (req, res) => {
    try {
        const connection = await mysql.createConnection(dbConfig);
        const [rows] = await connection.execute(`
      SELECT type_id, type_name, duration_days, price, description, max_daily_usage, original_price
      FROM membership_types 
      WHERE is_active = 1
      ORDER BY duration_days ASC
    `);
        await connection.end();

        const camelCaseData = rows.map(toCamelCase);

        // 加入 unitValue 和 unitLabel 字段
        const enrichedData = camelCaseData.map(item => {
            const isTimesCard = /次/.test(item.typeName) || item.durationDays === 0;
            return {
                ...item,
                unitValue: isTimesCard ? item.maxDailyUsage : item.durationDays,
                unitLabel: isTimesCard ? '次' : '天'
            };
        });

        res.json({
            success: true,
            data: enrichedData
        });
    } catch (err) {
        console.error('查询会员卡类型失败:', err);
        res.status(500).json({ success: false, message: '服务器错误' });
    }
};
//根据Id获取会员卡类型
exports.getCardTypeById = async (req, res) => {
    const { typeId } = req.params;
    try {
        const connection = await mysql.createConnection(dbConfig);

        // 获取卡类型详情
        const [rows] = await connection.execute(`
      SELECT type_id, type_name, duration_days, price, description, max_daily_usage, original_price,
             available_stores, valid_start_offset, valid_duration_type,
             per_use_duration_minutes, available_time
      FROM membership_types 
      WHERE is_active = 1 AND type_id = ?
      LIMIT 1
    `, [typeId]);

        if (rows.length === 0) {
            await connection.end();
            return res.status(404).json({ success: false, message: '未找到该类型' });
        }

        const data = toCamelCase(rows[0]);

        // 解析 availableStores 并获取门店详情
        let storeIds = [];
        try {
            storeIds = JSON.parse(data.availableStores || '[]');
        } catch {
            storeIds = [];
        }

        let storeDetails = [];
        if (storeIds.length > 0) {
            const placeholders = storeIds.map(() => '?').join(',');
            const [storeRows] = await connection.query(`
    SELECT store_id, store_name 
    FROM stores 
    WHERE store_id IN (${placeholders})
  `, storeIds);

            storeDetails = storeRows.map(store => toCamelCase(store));
        }

        await connection.end();

        data.availableStores = storeDetails;

        res.json({ success: true, data });
    } catch (err) {
        console.error('获取卡类型失败:', err);
        res.status(500).json({ success: false, message: '服务器错误' });
    }
};
