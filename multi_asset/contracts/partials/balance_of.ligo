#include "./action.ligo"

function balance_of (const balance_of_param : balance_of_param; const storage : storage) : (list(operation) * storage)
    is ((nil : list(operation)), storage)
