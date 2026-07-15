const { AppError } = require('../../common/errors/app-error');
const { toUserDto } = require('../users/user.dto');
const profileRepository = require('./profile.repository');

async function getByUserId(userId) {
  const user = await profileRepository.findUserWithProfile(userId);

  if (!user) {
    throw new AppError('Profile not found.', 404, 'PROFILE_NOT_FOUND');
  }

  return toUserDto(user);
}

async function updateByUserId(userId, payload) {
  const user = await profileRepository.updateByUserId(userId, payload);

  if (!user) {
    throw new AppError('Profile not found.', 404, 'PROFILE_NOT_FOUND');
  }

  return toUserDto(user);
}

module.exports = {
  getByUserId,
  updateByUserId,
};
