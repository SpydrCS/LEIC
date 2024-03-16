#ifndef AED_PROJ1_AVIAO_H
#define AED_PROJ1_AVIAO_H

#include "voo.h"
#include <list>

using namespace std;
class Aviao {
public:
    explicit Aviao(string m);
    void setTipo(string t);
    void setCapacidade(unsigned c);
    void addVoo(Voo v);
    void removeVoo(Voo v);
    string getMatricula();
    string getTipo();
    unsigned getCapacidade() const;
    list<Voo> planoVoo;
    string matricula;
    unsigned capacidade;
private:
    string tipo;
};



#endif //AED_PROJ1_AVIAO_H
