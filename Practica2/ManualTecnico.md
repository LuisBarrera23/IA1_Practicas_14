# Manual de Tecnico  
#### Universidad de San Carlos de Guatemala  
#### Facultad de Ingeniería  
#### Inteligencia Artificial 1  

## Práctica 2   
### Red Semántica de Plantas  

#### Nombre y carnet 
- Yeinny Melissa Catalán de León   - 202004725  
- Luis Angel Barrera Velásquez     - 202010223 

Guatemala, Junio 2024.  
___

## Introducción

Este manual técnico tiene como objetivo proporcionar una guía detallada para entender y utilizar el sistema de reglas lógicas implementado en Prolog. El sistema permite definir clases de objetos, sus propiedades, relaciones entre ellas y realizar consultas para obtener información específica sobre los objetos y sus características.

## Objetivos

### General

- Brindar al lector una guía completa sobre el manejo de las reglas lógicas en Prolog para la definición de objetos y sus propiedades.

### Específicos

- Mostrar cómo definir clases de objetos y relaciones entre ellas en Prolog.
- Explicar cómo realizar consultas para obtener propiedades y relaciones de los objetos definidos.

## Alcances del Sistema

Este sistema está diseñado para ser utilizado por estudiantes y profesionales interesados en aprender y aplicar lógica de programación en Prolog para la definición y consulta de objetos y propiedades.

## Herramientas Utilizadas

- Computadora con entorno Prolog instalado
- Editor de código para Prolog

## Implementación en Prolog

### Definición de Instancias de una clase 

```prolog
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
instancia_de(albahaca, planta_aromatica).
instancia_de(oregano, planta_aromatica).
```

En esta parte de código se hizo la relación de un objeto con su clase.

### Definición de Subclases de una clase 

```prolog
% subclase_de(Subclase, Clase)
subclase_de(flor, planta).
subclase_de(arbol, planta).
subclase_de(planta_suculenta, planta).
subclase_de(vegetal, planta_comestible).
subclase_de(fruta, planta_comestible).
subclase_de(vegetal, planta_comestible).
subclase_de(planta_comestible, planta).
subclase_de(planta_aromatica, planta_comestible).
```

En esta parte de código se hizo la relación de una subclase con su clase.


### Definición de propiedades

```prolog
% tiene_propiedad(Clase1, propiedad, Clase2)
tiene_propiedad(planta, necesita, agua).
tiene_propiedad(planta, necesita, sol).
tiene_propiedad(flor, tiene, petalos).
tiene_propiedad(arbol, tiene, copa).
tiene_propiedad(arbol, tiene, tronco).
tiene_propiedad(planta_suculenta, almacena, agua).
tiene_propiedad(fruta, es, comestible).
tiene_propiedad(vegetal, es, comestible).
tiene_propiedad(planta_aromatica, tiene, aroma).
```

En esta parte de código se hizo la relación de una clase con una propiedad de otra clase.

### Definición de partes de una planta

```prolog
% parte_de(Parte, Todo)
parte_de(hoja, planta).
parte_de(raiz, planta).
parte_de(semilla, fruto).
parte_de(fruto, planta).
parte_de(hoja, arbol).
parte_de(rama, planta).
parte_de(no_fruto, planta_aromatica).
parte_de(no_fruto, flor).
```

Esta es la etiqueta extra, aqui se relaciona una parte de la planta con la planta en sí.

### Definición de incompatibilidad

```prolog
incompatible(tiene(X), no_tiene(X)).
incompatible(no_tiene(X), tiene(X)).
incompatible(no_fruto, fruto).
incompatible(fruto, no_fruto).
```

Aquí se define la incompatibilidad que puede existir entre una clase y subclase.

### Definición de reglas  

#### Regla para saber si un objeto es instancia de otra clase  
```prolog
% Regla para saber si un objeto es una instancia de una clase en concreto
es(Clase, Obj):- instancia_de(Obj, Clase).
es(Clase, Obj):- instancia_de(Obj, Clasep),
                 subc(Clasep, Clase).

es(Clase, Obj, 0):- instancia_de(Obj, Clase).
es(Clase, Obj, Prio):- instancia_de(Obj, Clasep),
                       subcn(Clasep, Clase, Prio).
```  

#### Regla para saber si una clase es subclase de otra
```prolog
% Para identificar si una clase es subclase
subc(C1, C2):- subclase_de(C1, C2).
subc(C1, C2):- subclase_de(C1, C3),
               subc(C3, C2).

subcn(C1, C2, 1):- subclase_de(C1, C2).
subcn(C1, C2, N):- subclase_de(C1, C3),
                   subcn(C3, C2, M), N is M + 1.
```  

#### Regla para saber las propiedades de un objeto
```prolog
% Para obtener las propiedades de un objeto
propiedad(Obj, Prop, Prio):- es(Clase, Obj, Prio),
                             tiene_propiedad(Clase, Fun, Arg),
                             Prop =.. [Fun, Arg].

propiedad(Obj, Prop):- propiedad(Obj, Prop, Prio),
                       \+ incomp(Obj, Prop, Prio).
```

#### Regla para saber las partes de una planta
```prolog
% Regla para encontrar todas las partes de una planta
partesde(Obj, Parte, Prio) :- es(Clase, Obj, Prio),
                              parte_de(Parte, Clase).

partesde(Obj, Parte) :- partesde(Obj, Parte, Prio),
                        \+ incompar(Obj, Parte, Prio).
```

#### Reglas para manejar la incompatibilidad
```prolog
% Regla para encontrar incompatibilidad entre propiedades
incomp(Obj, Prop, Prio):- incompatible(Prop, Propp),
                          propiedad(Obj, Propp, Priop),
                          Priop =< Prio.

% Regla para encontrar incompatibilidad entre partes
incompar(Obj, Parte, Prio):- incompatible(Parte, Proppar),
                             partesde(Obj, Proppar, Priop),
                             Priop =< Prio.
```