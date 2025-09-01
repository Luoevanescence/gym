const express = require('express');
const { searchStoresByName } = require('../controllers/storeController');

const router = express.Router();

// GET /api/stores?name=xxx
router.get('/', searchStoresByName);

module.exports = router;
