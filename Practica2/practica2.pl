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
subclase_de(vegetal, planta).
subclase_de(fruta, planta_comestible).
subclase_de(vegetal, planta_comestible).
subclase_de(planta_comestible, planta).
subclase_de(planta_aromatica, planta_comestible).

% tiene_propiedad(Clase1, propiedad, Clase2)
tiene_propiedad(planta, necesita, agua).
tiene_propiedad(planta, necesita, luz_solar).
tiene_propiedad(flor, tiene, petalos).
tiene_propiedad(arbol, tiene, tronco).
tiene_propiedad(arbol, tiene, hojas).
tiene_propiedad(planta_suculenta, almacena, agua).
tiene_propiedad(fruta, es, comestible).
tiene_propiedad(vegetal, es, comestible).
tiene_propiedad(planta_aromatica, tiene, aroma).

%%%%%%REGLAS
%Regla para saber si un objeto pertenece a una clase
es(Clase, Obj):-instancia_de(Obj, Clase).
es(Clase, Obj):-instancia_de(Obj, Clasep),
                subc(Clasep, Clase).


%Para identificar si una clase es subclase
subc(C1, C2):-subclase_de(C1,C2).
subc(C1, C2):-subclase_de(C1,C3),
              subc(C3,C2).


%Para propiedad del objeto
propiedad(Obj,Prop):-es(Clase,Obj),
                     tiene_propiedad(Clase,Propiedad,Clase2),
                     Prop =.. [Propiedad, Clase2].