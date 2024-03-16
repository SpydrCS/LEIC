#ifndef AED_PROJ1_CARRINHOTRANSPORTE_H
#define AED_PROJ1_CARRINHOTRANSPORTE_H

#include <string>
#include "voo.h"
#include <list>

using namespace std;

class CarrinhoTransporte : public Voo {
public:
    CarrinhoTransporte(unsigned int c1, unsigned int n1, unsigned int m1, string m2, unsigned c,
                       unsigned n, unsigned int m);
    unsigned getCarruagens() const;
    unsigned getPilhas() const;
    unsigned getMalas() const;
    unsigned getMaxMalas() const;
    void malasIntoCarrinho();
    vector<Bagagens> vector_malas;
    vector<vector<Bagagens>> vector_pilhas;
    vector<vector<vector<Bagagens>>> vector_carruagens;
    unsigned maxMalas;
private:
    unsigned carruagens;
    unsigned pilhas;
    unsigned malas;
};

#endif //AED_PROJ1_CARRINHOTRANSPORTE_H