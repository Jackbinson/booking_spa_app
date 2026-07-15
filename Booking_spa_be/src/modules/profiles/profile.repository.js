const { getDb } = require('../../config/database');
const profileModel = require('./profile.model');

async function findByUserId(userId) {
  return getDb()(profileModel.tableName).where({ user_id: userId }).first();
}

async function findUserWithProfile(userId, db = getDb()) {
  const user = await db('users').where({ id: userId }).first();
  if (!user) {
    return null;
  }

  const profile = await db(profileModel.tableName).where({ user_id: userId }).first();
  return { ...user, profile };
}

async function updateByUserId(userId, payload) {
  const db = getDb();

  return db.transaction(async (trx) => {
    const userChanges = {};
    if (payload.fullName !== undefined) {
      userChanges.full_name = payload.fullName;
    }
    if (payload.phone !== undefined) {
      userChanges.phone = payload.phone;
    }
    if (Object.keys(userChanges).length > 0) {
      userChanges.updated_at = trx.fn.now();
      await trx('users').where({ id: userId }).update(userChanges);
    }

    const profileChanges = {};
    const fields = {
      avatarUrl: 'avatar_url',
      birthDate: 'birth_date',
      gender: 'gender',
      address: 'address',
      preferences: 'preferences',
    };
    for (const [inputKey, column] of Object.entries(fields)) {
      if (payload[inputKey] !== undefined) {
        profileChanges[column] = payload[inputKey];
      }
    }
    if (Object.keys(profileChanges).length > 0) {
      profileChanges.updated_at = trx.fn.now();
      await trx(profileModel.tableName).where({ user_id: userId }).update(profileChanges);
    }

    return findUserWithProfile(userId, trx);
  });
}

module.exports = {
  findByUserId,
  findUserWithProfile,
  updateByUserId,
};
