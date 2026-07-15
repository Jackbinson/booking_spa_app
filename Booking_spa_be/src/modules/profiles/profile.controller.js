const profileService = require('./profile.service');
const { saveServiceImage } = require('../spa-services/spa-service-image-upload');
const { sendSuccess } = require('../../common/utils/api-response');

async function getMyProfile(req, res) {
  const profile = await profileService.getByUserId(req.user.id);
  return sendSuccess(res, profile);
}

async function updateMyProfile(req, res) {
  const profile = await profileService.updateByUserId(req.user.id, req.validated.body);
  return sendSuccess(res, profile, 'Profile updated.');
}

async function uploadMyAvatar(req, res) {
  const fileName = await saveServiceImage({
    buffer: req.body,
    contentType: req.get('content-type') || '',
  });
  const imageUrl = `${req.protocol}://${req.get('host')}/static/uploads/services/${fileName}`;
  const profile = await profileService.updateByUserId(req.user.id, { avatarUrl: imageUrl });
  return sendSuccess(res, profile, 'Profile image updated.');
}

module.exports = {
  getMyProfile,
  updateMyProfile,
  uploadMyAvatar,
};
