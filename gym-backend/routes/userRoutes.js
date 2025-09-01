const express = require('express');
const { wxLogin, updateUser,getUserInfo } = require('../controllers/userController');
const router = express.Router();
router.get('/info/:userId', getUserInfo);
router.post('/wxlogin', wxLogin);
router.post('/update', updateUser);
module.exports = router;