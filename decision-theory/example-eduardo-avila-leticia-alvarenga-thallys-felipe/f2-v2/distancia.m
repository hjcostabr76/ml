% funcao que testa a distancia do cliente ao router
function distancia = distancia(x1, y1, x2, y2)
distancia = ( sqrt( ((x1-x2)^2) + ((y1-y2)^2) ) );
end