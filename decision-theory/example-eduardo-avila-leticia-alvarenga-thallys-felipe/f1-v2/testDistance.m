% funcao que testa a distancia do cliente ao router
function flag = testDistance(x1, y1, x2, y2)
flag = ( sqrt( ((x1-x2)^2) + ((y1-y2)^2) ) < 85 );
end