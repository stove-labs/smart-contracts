#include "./../../multi_asset/src/action.ligo"

type payout_param is unit;

type action is

| Transfer of transfer_param

| Balance_of of balance_of_param

| Add_operator of modify_operator_param

| Remove_operator of modify_operator_param

| Is_operator of is_operator_param

| Payout of payout_param