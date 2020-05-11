--1. �������� ������� �����.

ALTER TABLE [order]
ADD
FOREIGN KEY(id_production) REFERENCES production(id_production)

ALTER TABLE [order]
ADD
FOREIGN KEY(id_dealer) REFERENCES dealer(id_dealer)

ALTER TABLE [order]
ADD
FOREIGN KEY(id_pharmacy) REFERENCES pharmacy(id_pharmacy)

ALTER TABLE production
ADD
FOREIGN KEY(id_company) REFERENCES company(id_company)

ALTER TABLE production
ADD
FOREIGN KEY(id_medicine) REFERENCES medicine(id_medicine)

ALTER TABLE dealer
ADD
FOREIGN KEY(id_company) REFERENCES company(id_company)


--2. ������ ���������� �� ���� ������� ��������� ��������� �������� ������ � ��������� �������� �����, ���, ������ �������.

SELECT pharmacy.name, [order].date, [order].quantity
FROM medicine
INNER JOIN production ON production.id_medicine = medicine.id_medicine
INNER JOIN company ON company.id_company = production.id_company
INNER JOIN [order] ON [order].id_production = production.id_production
INNER JOIN pharmacy ON pharmacy.id_pharmacy = [order].id_pharmacy
WHERE (medicine.name = N'��������' AND company.name = N'�����')


--3. ���� ������ �������� �������� �������, �� ������� �� ���� ������� ������ �� 25 ������.

SELECT DISTINCT medicine.name
FROM medicine
LEFT JOIN production ON production.id_medicine = medicine.id_medicine
LEFT JOIN company ON company.id_company = production.id_company
LEFT JOIN [order] ON [order].id_production = production.id_production
WHERE company.name = N'�����' AND
	production.id_production NOT IN 
	(
		SELECT [order].id_production
		FROM [order]
		WHERE [order].date < N'2019-01-25'
	)


--4. ���� ����������� � ������������ ����� �������� ������ �����, ������� �������� �� ����� 120 �������.

SELECT company.name, MIN(production.rating) AS min_rating, MAX(production.rating) AS max_rating
FROM production
INNER JOIN company ON company.id_company = production.id_company
INNER JOIN [order] ON [order].id_production = production.id_production
GROUP BY company.name
HAVING COUNT([order].id_order) >= 120


--5. ���� ������ ��������� ������ ����� �� ���� ������� �������� �AstraZeneca�. ���� � ������ ��� �������, � �������� ������ ���������� NULL.

SELECT dealer.name, pharmacy.name
FROM dealer
LEFT JOIN [order] ON [order].id_dealer = dealer.id_dealer
LEFT JOIN pharmacy ON pharmacy.id_pharmacy = [order].id_pharmacy
LEFT JOIN company ON company.id_company = dealer.id_company
WHERE company.name = N'AstraZeneca'


--6. ��������� �� 20% ��������� ���� ��������, ���� ��� ��������� 3000, � ������������ ������� �� ����� 7 ����.

BEGIN TRANSACTION

UPDATE production
SET production.price = production.price * 0.8
FROM production
INNER JOIN medicine ON medicine.id_medicine = production.id_medicine
WHERE (production.price > 3000 AND medicine.cure_duration <= 7)
	
ROLLBACK

--7. �������� ����������� �������.

-- pharmacy
CREATE NONCLUSTERED INDEX [IX_pharmacy_name] ON pharmacy
(
	name ASC
)

-- order
CREATE NONCLUSTERED INDEX [IX_order_date-quantity] ON [order]
(
	date ASC,
	quantity ASC
)
CREATE NONCLUSTERED INDEX [IX_order_id_production] ON [order]
(
	id_production ASC
)
CREATE NONCLUSTERED INDEX [IX_order_id_dealer] ON [order]
(
	id_dealer ASC
)

-- dealer
CREATE NONCLUSTERED INDEX [IX_dealer_name] ON dealer
(
	name ASC
)
CREATE NONCLUSTERED INDEX [IX_dealer_id_company] ON dealer
(
	id_company ASC
)

-- company
CREATE NONCLUSTERED INDEX [IX_company_name] ON company
(
	name ASC
)

-- production
CREATE NONCLUSTERED INDEX [IX_production_id_medicine] ON production
(
	id_medicine ASC
)
CREATE NONCLUSTERED INDEX [IX_production_id_company] ON production
(
	id_company ASC
)
CREATE NONCLUSTERED INDEX [IX_production_rating] ON production
(
	rating ASC
)
CREATE NONCLUSTERED INDEX [IX_production_price] ON production
(
	price ASC
)

-- medicine
CREATE NONCLUSTERED INDEX [IX_medicine_name] ON medicine
(
	name ASC
)