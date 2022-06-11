
--Data Cleaning using SQL


Select *
From dbo.Housingprojects



-- Converting Date and time Format


Select saleDateConverted, CONVERT(Date,SaleDate)
From dbo.Housingprojects

ALTER TABLE Housingprojects
Add SaleDateConverted Date;

Update Housingprojects
SET SaleDateConverted = CONVERT(Date,SaleDate)


 --Property Address data

Select *
From dbo.Housingprojects
order by ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From dbo.Housingprojects a
JOIN dbo.Housingprojects b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From dbo.Housingprojects a
JOIN dbo.Housingprojects b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From dbo.Housingprojects

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From dbo.Housingprojects


ALTER TABLE Housingprojects
Add PropertySplitAddress Nvarchar(255);

Update Housingprojects
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE Housingprojects
Add PropertySplitCity Nvarchar(255);

Update Housingprojects
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




Select *
From dbo.Housingprojects





Select OwnerAddress
From dbo.Housingprojects


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From dbo.Housingprojects



ALTER TABLE Housingprojects
Add OwnerSplitAddress Nvarchar(255);

Update Housingprojects
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE Housingprojects
Add OwnerSplitCity Nvarchar(255);

Update Housingprojects
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE Housingprojects
Add OwnerSplitState Nvarchar(255);

Update Housingprojects
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From dbo.Housingprojects


-- Changing Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From dbo.Housingprojects
Group by SoldAsVacant
order by 2


Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From dbo.Housingprojects

Update Housingprojects
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END


-- Removing Duplicates

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

From dbo.Housingprojects
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From dbo.Housingprojects


-- Delete Unused Columns



Select *
From dbo.Housingprojects


ALTER TABLE dbo.Housingprojects
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate