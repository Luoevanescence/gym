const express = require('express');
const router = express.Router();
const multer = require('multer');
const uploadController = require('../controllers/uploadController');

const upload = multer({ dest: 'uploads/' }); 

router.post('/upload-to-github', upload.single('file'), uploadController.uploadToGitHub);
router.get('/test', (req, res) => {
    res.send('Upload route is working!');
});
module.exports = router;
