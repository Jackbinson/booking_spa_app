exports.up = async function up(knex) {
  await knex.schema.alterTable('bookings', (table) => {
    table.string('customer_name', 120);
    table.string('customer_phone', 20);
  });

  await knex.raw(`
    update bookings
    set
      customer_name = users.full_name,
      customer_phone = users.phone
    from users
    where bookings.user_id = users.id
  `);
};

exports.down = async function down(knex) {
  await knex.schema.alterTable('bookings', (table) => {
    table.dropColumn('customer_phone');
    table.dropColumn('customer_name');
  });
};
