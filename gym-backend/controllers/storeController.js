const mysql = require('mysql2/promise');
const dbConfig = require('../config/db');

exports.searchStoresByName = async (req, res) => {
  const { name } = req.query;
  const keyword = name || '';

  console.log('[searchStoresByName] 接收到 name:', name);

  try {
    const connection = await mysql.createConnection(dbConfig);
    const [stores] = await connection.execute(
      'SELECT * FROM stores WHERE store_name LIKE ?',
      [`%${keyword}%`]
    );
    await connection.end();

    console.log('[searchStoresByName] 查询到记录数:', stores.length);

    res.json({
      success: true,
      data: stores.map(store => ({
        latitude: parseFloat(store.latitude),
        longitude: parseFloat(store.longitude),
        id: store.store_code,
        storeName: store.store_name,
        distance: '',
        address: store.address,
        currentPeople: store.current_people,
        mainImage: store.main_image,
        phone: store.phone,
        equipmentTypes: store.equipment_types,
        businessHours: store.business_hours,
        addressMap: store.map_image
      }))
    });
  } catch (err) {
    console.error('查询门店失败:', err);
    res.status(500).json({
      success: false,
      message: '服务器错误',
      error: err.message
    });
  }
};
