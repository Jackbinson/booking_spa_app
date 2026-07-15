exports.up = async function up(knex) {
  await knex.schema.alterTable('profiles', (table) => {
    table.jsonb('preferences').notNullable().defaultTo(knex.raw("'{}'::jsonb"));
  });
};

exports.down = async function down(knex) {
  await knex.schema.alterTable('profiles', (table) => {
    table.dropColumn('preferences');
  });
};
