#include "./storage.ligo"
#include "./action.ligo"

function main (const action : action; const storage : storage) : (list(operation) * storage)
    is ((nil : list(operation)), storage)