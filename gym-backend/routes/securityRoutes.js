const express = require('express');
const router = express.Router();
const securityController = require('../controllers/securityController');

router.post('/submit', securityController.submitRepairRequest);
router.get('/list', securityController.getRepairRecords);

module.exports = router;