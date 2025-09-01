const express = require('express');
const { scanOpenDoor,getAccessRecordsByUserId } = require('../controllers/accessController');
const router = express.Router();

router.post('/scan', scanOpenDoor); // 扫码开门接口
router.get('/records', getAccessRecordsByUserId);
module.exports = router;
