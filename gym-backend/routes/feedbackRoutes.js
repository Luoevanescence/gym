const express = require('express');
const router = express.Router();
const {
  submitUserFeedback,
  getUserFeedbacks
} = require('../controllers/feedbackController');

router.post('/submit', submitUserFeedback); // 提交反馈
router.get('/list', getUserFeedbacks); // 查询某用户的所有反馈

module.exports = router;