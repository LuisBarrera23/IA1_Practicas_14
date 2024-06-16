% instancia_de(Objeto, Clase)
instancia_de(rosa, flor).
instancia_de(margarita, flor).
instancia_de(lirio, flor).
instancia_de(roble, arbol).
instancia_de(pino, arbol).
instancia_de(cactus, planta_suculenta).
instancia_de(aloevera, planta_suculenta).
instancia_de(cebolla, vegetal).
instancia_de(zanahoria, vegetal).
instancia_de(tomate, fruta).
instancia_de(manzana, fruta).
instancia_de(tulipan, flor).
instancia_de(sauco, arbol).
instancia_de(menta, planta_aromatica).
instancia_de(romero, planta_aromatica).
instancia_de(papa, vegetal).
instancia_de(basil, planta_aromatica).
instancia_de(oregano, planta_aromatica).

% subclase_de(Subclase, Clase)
subclase_de(flor, planta).
subclase_de(arbol, planta).
subclase_de(planta_suculenta, planta).
subclase_de(vegetal, planta_comestible).
subclase_de(fruta, planta_comestible).
subclase_de(vegetal, planta_comestible).
subclase_de(planta_comestible, planta).
subclase_de(planta_aromatica, planta_comestible).

% tiene_propiedad(Clase1, propiedad, Clase2)
tiene_propiedad(planta, necesita, agua).
tiene_propiedad(planta, necesita, sol).
tiene_propiedad(flor, tiene, petalos).
tiene_propiedad(arbol, tiene, tronco).
tiene_propiedad(arbol, tiene, hojas).
tiene_propiedad(planta_suculenta, almacena, agua).
tiene_propiedad(fruta, es, comestible).
tiene_propiedad(vegetal, es, comestible).
tiene_propiedad(planta_aromatica, tiene, aroma).
tiene_propiedad(planta, no_tiene, aroma).

% parte_de(Parte, Todo)
parte_de(hoja, planta).
parte_de(flor, planta).
parte_de(raiz, planta).
parte_de(tronco, arbol).
parte_de(rama, arbol).
parte_de(semilla, fruto).
parte_de(fruto, planta).
parte_de(hoja, arbol).
parte_de(rama, planta).
parte_de(flor, vegetal).
parte_de(hoja, vegetal).
parte_de(raiz, vegetal).
parte_de(no_fruto, planta_aromatica).
parte_de(no_fruto, flor).

incompatible(fruto(X), no_fruto(X)).
incompatible(tiene(X), no_tiene(X)).
incompatible(no_tiene(X), tiene(X)).
incompatible(no_fruto(X), fruto(X)).


%%%%%% REGLAS
% Regla para saber si un objeto es una instancia de una clase en concreto
es(Clase, Obj):- instancia_de(Obj, Clase).
es(Clase, Obj):- instancia_de(Obj, Clasep),
                 subc(Clasep, Clase).

es(Clase, Obj, 0):- instancia_de(Obj, Clase).
es(Clase, Obj, Prio):- instancia_de(Obj, Clasep),
                       subcn(Clasep, Clase, Prio).

% Para identificar si una clase es subclase
subc(C1, C2):- subclase_de(C1, C2).
subc(C1, C2):- subclase_de(C1, C3),
               subc(C3, C2).

subcn(C1, C2, 1):- subclase_de(C1, C2).
subcn(C1, C2, N):- subclase_de(C1, C3),
                   subcn(C3, C2, M), N is M + 1.

% Para obtener las propiedades de un objeto
propiedad(Obj, Prop, Prio):- es(Clase, Obj, Prio),
                             tiene_propiedad(Clase, Fun, Arg),
                             Prop =.. [Fun, Arg].

propiedad(Obj, Prop):- propiedad(Obj, Prop, Prio),
                       \+ incomp(Obj, Prop, Prio).

% Regla para encontrar todas las partes de una planta
partesde(Obj, Parte, Prio) :- es(Clase, Obj, Prio),
                              parte_de(Parte, Clase).

partesde(Obj, Parte) :- partesde(Obj, Parte, Prio),
                        \+ incompar(Obj, Parte, Prio).

% Regla para encontrar incompatibilidad entre propiedades
incomp(Obj, Prop, Prio):- incompatible(Prop, Propp),
                          propiedad(Obj, Propp, Priop),
                          Priop =< Prio.

% Regla para encontrar incompatibilidad entre propiedades
incompar(Obj, Parte, Prio):- incompatible(Parte, Proppar),
                          partesde(Obj, Proppar, Priop),
                          Priop =< Prio.
