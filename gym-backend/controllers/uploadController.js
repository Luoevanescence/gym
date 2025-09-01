const fs = require('fs');
const axios = require('axios');

// GitHub 配置
const GITHUB_USERNAME = 'github用户名';
const GITHUB_REPO = 'github仓库名';
const GITHUB_BRANCH = 'github main分支';
const GITHUB_TOKEN = '你的GitHub Token';
const FILE_FOLDER = 'GitHub 仓库中的文件夹路径'; 

exports.uploadToGitHub = async (req, res) => {
  const file = req.file;
  if (!file) return res.status(400).json({ success: false, message: '未接收到文件' });

  const fileContent = fs.readFileSync(file.path);
  const base64Content = fileContent.toString('base64');
  const fileName = `${Date.now()}_${file.originalname}`;
  const filePath = `${FILE_FOLDER}/${fileName}`;

  try {
    const githubApiUrl = `https://api.github.com/repos/${GITHUB_USERNAME}/${GITHUB_REPO}/contents/${filePath}`;

    const response = await axios.put(githubApiUrl, {
      message: `upload avatar ${fileName}`,
      content: base64Content,
      branch: GITHUB_BRANCH
    }, {
      headers: {
        Authorization: `token ${GITHUB_TOKEN}`,
        'User-Agent': 'GitHub-Uploader'
      }
    });

    const rawUrl = `https://raw.githubusercontent.com/${GITHUB_USERNAME}/${GITHUB_REPO}/${GITHUB_BRANCH}/${filePath}`;
    res.json({ success: true, url: rawUrl });
  } catch (err) {
    console.error('上传失败:', err.response?.data || err.message);
    res.status(500).json({ success: false, message: '上传失败', error: err.message });
  } finally {
    fs.unlinkSync(file.path);
  }
};
