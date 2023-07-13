//
// Created by andre on 17/12/2021.
//

#include "bagagens.h"

#include <utility>

Bagagens::Bagagens(string d, unsigned int p, unsigned int v) {
    dono = std::move(d);
    peso = p;
    volume = v;
}
string Bagagens::getDono() {
    return dono;
}
unsigned Bagagens::getPeso() const {
    return peso;
}
unsigned Bagagens::getVolume() const {
    return volume;
}