ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('nl_jobGranjero:DarPago') 
AddEventHandler('nl_jobGranjero:DarPago', function(source, leche, payment)
    local _source = source
    local xPlayer  = ESX.GetPlayerFromId(_source)
    xPlayer.addAccountMoney('money', payment)
end)

RegisterServerEvent('nl_jobGranjero:PayPigs') 
AddEventHandler('nl_jobGranjero:PayPigs', function(source)
    local _source = source
    local xPlayer  = ESX.GetPlayerFromId(_source)
    xPlayer.addAccountMoney('money', Config.PigsPayment)
end)