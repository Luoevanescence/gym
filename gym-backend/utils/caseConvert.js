// utils/caseConvert.js
function toCamelCase(row) {
  const result = {};
  for (const key in row) {
    if (Object.hasOwnProperty.call(row, key)) {
      const camelKey = key.replace(/_([a-z])/g, (_, letter) => letter.toUpperCase());
      const value = row[key];

      // 如果是 Date 类型，转换为 ISO 字符串或格式化字符串
      result[camelKey] = value instanceof Date ? value.toISOString() : value;
    }
  }
  return result;
}

module.exports = {
  toCamelCase
};
