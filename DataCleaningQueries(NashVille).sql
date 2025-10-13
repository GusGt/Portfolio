Select *
From Portfolio_Prog..NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Select SaleDateConverted, CONVERT(Date,SaleDate)
From Portfolio_Prog..NashvilleHousing

Update NashvilleHousing
Set SaleDate = Convert(Date,SaleDate)

--Removing arbitrary time from SaleDate
ALTER TABLE NashvilleHousing
add SaleDateConverted Date;

Update NashvilleHousing
Set SaleDateConverted = Convert(Date,SaleDate)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--Populating Adress Data

Select *
From Portfolio_Prog..NashvilleHousing
where PropertyAddress is null
--Can not have NULL adress for real properties, must remove

Select * 
From Portfolio_Prog..NashvilleHousing
order by ParcelID
--Shows Numerous duplicates that can be quickly found with PARCELID as a reference

--join to locate Errors
Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress) 
From Portfolio_Prog..NashvilleHousing A
Join Portfolio_Prog..NashvilleHousing B
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

--Fixing Null values

UPDATE a
Set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress) 
From Portfolio_Prog..NashvilleHousing A
Join Portfolio_Prog..NashvilleHousing B
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null
--Succesful Update for Null values regarding property adresses

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--At first Addresses where combined, we want separate (Adress, City, State)
Select PropertyAdress
From Portfolio_Prog..NashvilleHousing

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
,SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress)) as Address
From Portfolio_Prog..NashvilleHousing

ALTER TABLE NashvilleHousing
add PropertyAddressSplit NVARCHAR(255);

Update NashvilleHousing
Set PropertyAddressSplit = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


ALTER TABLE NashvilleHousing
add PropertyCitySplit NVARCHAR(255);

Update NashvilleHousing
Set PropertyCitySplit = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress))


--Searching for State of each property located in OWNERADDRESS with the use of PARSENAME
Select OwnerAddress
From Portfolio_Prog..NashvilleHousing


ALTER TABLE NashvilleHousing
add PropertyStateSplit NVARCHAR(255);

Update NashvilleHousing
Set PropertyStateSplit = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1) --finds last piece of OwnerAddress which is the STATE

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Table Column 'SOLDASVACANT' has four different cases Y,N,YES,NO. Need to limit to only two (YES, NO)

Select Distinct(Soldasvacant), COUNT(SoldAsVacant)
From Portfolio_Prog..NashvilleHousing
group by SoldAsVacant


UPDATE NashvilleHousing
Set SoldAsVacant =
	 CASE when SoldAsVacant = 'Y' THEN 'YES'
		  when SoldAsVacant = 'N' THEN 'NO'
		  ELSE SoldAsVacant
		  END
From Portfolio_Prog..NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Process of removing duplicates and unused columns


--these are the duplicates found
WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 Order BY
					UniqueID
					) row_num
From Portfolio_Prog..NashvilleHousing
)
Select * -- 'SELECT *' -> DELETE (removed dupes)
From RowNumCTE
where row_num > 1
--order by PropertyAddress



--Unused columns removals


Select *
From Portfolio_Prog..NashvilleHousing

ALTER TABLE Portfolio_Prog..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE Portfolio_Prog..NashvilleHousing
DROP COLUMN SaleDate

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------