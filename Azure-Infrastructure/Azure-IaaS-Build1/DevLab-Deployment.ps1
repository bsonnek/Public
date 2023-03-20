Set-ExecutionPolicy RemoteSigned
Install-Module AzureRM
Import-Module AzureRM
Connect-AzureRmAccount

#Resource Group and Location

$rg = "rsg-nc-SB-DEVLAB-VNET"

$location = "NorthCentralUS"



#VNET Name and Address Space

$VNETName = "VNET-SB-DEVLAB"

$VNETAddressSpace = "10.200.0.0/16"



#Subnet Configurations

$Serversubnet = New-AzVirtualNetworkSubnetConfig -Name "Server_subnet_10-200-10-0" -AddressPrefix "10.200.10.0/24"

$RDSPoolsubnet = New-AzVirtualNetworkSubnetConfig -Name "RDS_POOL_subnet_10-200-20-0" -AddressPrefix "10.200.20.0/24"

$RDSDMZsubnet = New-AzVirtualNetworkSubnetConfig -Name "RDS_DMZ_subnet_10-200-5-0" -AddressPrefix "10.200.5.0/24"



#Create Resource Group

New-AzResourceGroup -Name $rg -Location $location


#Create VNET and Subnets

$virtualNetwork = New-AzVirtualNetwork -Name $VNETName -ResourceGroupName $rg -Location $location -AddressPrefix $VNETAddressSpace -Subnet $Serversubnet,$RDSPoolsubnet,$RDSDMZsubnet



#Write the changes to the VNET

$virtualNetwork | Set-AzVirtualNetwork


###########################
##  Domain Controllers #
###########################
$creds = (Get-Credential)


    New-AzVM `
        -ResourceGroupName "rsg-nc-SBDEV-DC" `
        -Name "SBDEV-DC01" `
        -Location $location `
        -VirtualNetworkName $VNETName `
        -SubnetName $Serversubnet `
        -SecurityGroupName "Server_subnet_SecurityGroup" `
        -Credential $creds



###########################
##  RD Gateway Servers #
###########################


    New-AzVM `
        -ResourceGroupName "rsg-nc-SBDEV-RDGW"`
        -Name "SBDEV-RDGW01" `
        -Location $location `
        -VirtualNetworkName $VNETName `
        -SubnetName $RDSDMZsubnet `
        -SecurityGroupName "Server_subnet_SecurityGroup" `
        -PublicIpAddressName "SBDEV-RDGW-PublicIP" `
        -OpenPorts 80,3389 `
        -Credential $creds


###########################
##  RD Connection Broker Servers #
###########################



    New-AzVM `
        -ResourceGroupName "rsg-nc-SBDEV-RDCB" `
        -Name "SBDEV-RDCB01" `
        -Location $location `
        -VirtualNetworkName $VNETName `
        -SubnetName $RDSPoolsubnet `
        -SecurityGroupName "RDPool_subnet_SecurityGroup" `
        -Credential $creds


###########################
##  RD Server Pool Servers #
###########################

for ($i=1; $i -le 2; $i++)
{
    New-AzVM `
        -ResourceGroupName "rsg-nc-SBDEV-RDSH" `
        -Name "SBDEV-RDSH0$i" `
        -Location $location `
        -VirtualNetworkName $VNETName `
        -SubnetName $RDSPoolsubnet `
        -SecurityGroupName "RDPool_subnet_SecurityGroup" `
        -Credential $creds
}
