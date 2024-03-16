#ifndef AED_PROJ1_SERVICO_H
#define AED_PROJ1_SERVICO_H

#include <string>
#include <queue>
#include "avião.h"

using namespace std;

class Servico {
public:
    Servico(string t, string d, string f, Aviao a);
    void addServico(Servico s);
    void removeServico(Servico s);
    void moveServicoParaRealizado(Servico s);
    void removeServicoRealizado(Servico s);
    queue<Servico> servicos;
    queue<Servico> servicosRealizados;
private:
    string tipo;
    string data;
    string funcionario;
};


#endif //AED_PROJ1_SERVICO_H
