const express = require('express');
const router = express.Router();
const cardController = require('../controllers/cardController');

// 获取所有会员卡类型
router.get('/types', cardController.getAllCardTypes);
router.get('/types/:typeId', cardController.getCardTypeById); 
module.exports = router;