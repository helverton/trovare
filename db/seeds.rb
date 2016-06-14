# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Ramo.create(nome: 'Prestador de serviços')  

Entidade.create(nome: 'Trovare Servizio', ramo_id: '1')

User.create(nome: 'master', email: 'master@email.com', password: '12345', status: '1', password_confirmation: '12345', tipo: '1', entidade_id: '1')


Ramo.create(nome: 'Salão de beleza')  

Entidade.create(nome: 'Salão da Maria', estado: 'PR', cidade: 'Curitiba', contato: 'Maria', status: 1, ramo_id: '2')

User.create(nome: 'Maria', email: 'maria@email.com', status: '1', password: '12345', password_confirmation: '12345', tipo: '2', entidade_id: '2')