# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

MapVariable.delete_all
map_variable = MapVariable.create([{name:"Expense"}, {name:"Cash"}, {name: "Income"}, {name:"EMI"},{name:"Premium"},{name:"Debt"},{name:"Assets"},{name:"Sum Assured"},{name:"Retirement Savings"}])

FinanceMeasure.delete_all
measures = FinanceMeasure.create([
	{name:"Liquidity Ratio", equation:"(2/1)"},
	{name:"Expense Ratio", equation:"(1/3)"},
	{name:"Loan to Income Ratio", equation:"(4/3)"},
	{name:"Premium to Income Ratio", equation:"(5/(3*12))"},
	{name:"Debt To Asset Ratio", equation:"(6/7)"},
	{name:"Insurrance Cover Ratio", equation:"(8/(3*12))"},
	{name:"Retirement Ratio", equation:"(9/3)"},
	{name:"Savinds rate Ratio", equation:"((3-1-4-5)/3)"}
	])