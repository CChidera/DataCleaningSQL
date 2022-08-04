

-- Data Cleaning in SQL Queries--
--Skills used in Cleaning the data.

--1. Convert to Date
--2. Using SubString and ParseName Function
--3. Alter Date
--4. Update Date
--5. Remove Duplicates
--6. Delete Unused Columns

-----------------------------------------------------------------------------------------
--1
-- This is to select and view the overall data
Select *
from Housing
where OwnerName is not NULL
Order by  5, 9

-----------------------------------------------------------------------------------------
--2
-- To Standardize the SalesDate Column to Date 

Select SaleDateConverted, CONVERT(Date,SaleDate)
From HousingDataCleaningProject.dbo.Housing

Update Housing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE Housing
Add SaleDateConverted Date;

Update Housing
SET SaleDateConverted = CONVERT(Date,SaleDate)


-----------------------------------------------------------------------------------------
--3
-- Populate Property Address data using a self join.

Select *
From HousingDataCleaningProject.dbo.Housing
--Where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From HousingDataCleaningProject.dbo.housing a
JOIN HousingDataCleaningProject.dbo.Housing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From HousingDataCleaningProject.dbo.Housing a
JOIN HousingDataCleaningProject.dbo.Housing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


-----------------------------------------------------------------------------------------
--4
-- Breaking out Address into Individual Columns (Address, City, State) using Substring and Parsename
Select PropertyAddress
From HousingDataCleaningProject.dbo.Housing

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address
From HousingDataCleaningProject.dbo.Housing

ALTER TABLE housing
Add PropertySplitAddress Nvarchar(255);

Update Housing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

ALTER TABLE housing
Add PropertySplitCity Nvarchar(255);

Update Housing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

Select *
From HousingDataCleaningProject.dbo.Housing


-----------------------------------------------------------------------------------------
--5 Using Parsename
Select OwnerAddress
From HousingDataCleaningProject.dbo.Housing

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From HousingDataCleaningProject.dbo.Housing

ALTER TABLE Housing
Add OwnerSplitAddress Nvarchar(255);

Update Housing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

ALTER TABLE Housing
Add OwnerSplitCity Nvarchar(255);

Update Housing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE Housing
Add OwnerSplitState Nvarchar(255);

Update Housing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

Select *
From HousingDataCleaningProject.dbo.Housing


-----------------------------------------------------------------------------------------
--6
-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From HousingDataCleaningProject.dbo.Housing
Group by SoldAsVacant
order by 2

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From HousingDataCleaningProject.dbo.Housing

Update Housing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END


-----------------------------------------------------------------------------------------
--7
	   -- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From HousingDataCleaningProject.dbo.Housing
--order by ParcelID
)
--Delete
Select*
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress

Select *
From HousingDataCleaningProject.dbo.Housing


-----------------------------------------------------------------------------------------
--8
-- Delete Unused Columns
Select *
From HousingDataCleaningProject.dbo.Housing


ALTER TABLE HousingDataCleaningProject.dbo.Housing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
