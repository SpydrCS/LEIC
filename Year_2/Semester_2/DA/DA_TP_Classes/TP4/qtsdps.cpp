#include <vector>
#include <algorithm>
#include "graph.h"

using namespace std;

int extra(vector<string> words) {
    vector<char> letters;
    for (auto word : words) {
        if (word == "#") break;
        for (int j = 0; j < word.size(); j++) {
            int count = 0;
            for (auto x : letters) {
                if (count > 0) break;
                if (word[j] == x) count++;
            }
            if (count == 0) letters.push_back(word[j]);
        }
    }
    sort(letters.begin(),letters.end());
    Graph g1(letters.size(), false);
    for (char ch : letters) {
        g1.addEdge();
    }

    return letters.size();
};

/// TESTS ///
#include <gtest/gtest.h>

TEST(TP4_Ex6, testExtra) {
    vector<string> help = {"MPMAAC","MPAMJ","MMCAA","MMJA","CAAP","CAAJP","#","P"};
    EXPECT_EQ(extra(help), 5);
}