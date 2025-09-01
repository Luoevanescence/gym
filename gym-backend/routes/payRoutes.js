const express = require('express');
const router = express.Router();
const { createOrder, getOrdersByUserId } = require('../controllers/payController');

router.post('/create-order', createOrder);
router.get('/orders', getOrdersByUserId);
module.exports = router;