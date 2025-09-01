/**
 * 校验手机号：允许为空，有值时必须符合格式
 * @param {string} phone - 手机号
 * @returns {boolean}
 */
export const validatePhoneOptional = (phone) => {
  const trimmed = (phone || '').trim()
  if (!trimmed) return true // 为空则通过
  const pattern = /^1[3-9]\d{9}$/
  return pattern.test(trimmed)
}