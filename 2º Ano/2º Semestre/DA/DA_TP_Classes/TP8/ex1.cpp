#include "string"
#include "vector"
#include "iostream"

using namespace std;

int editDist(string str1, string str2) {
    int count = 0;
    int mini;
    vector<vector<int>> de;

    for (int i = 0; i < str1.size(); i++) {
        de[i][0] = i;
    }
    for (int j = 0; j < str2.size(); j++) {
        de[0][j] = j;
    }

    for (int i = 1; i < str1.size(); i++) {
        for (int j = 1; j < str2.size(); j++) {
            if (str1[i] == str2[j]) count = 0;
            else {
                count = 1;
            }
            mini = min(de[i-1][j-1]+count, de[i-1][j]+1);
            de[i][j] = min(mini,de[i][j-1]+1);
        }
    }
    return de[str1.size()-1][str2.size()-1];
}

int main() {
    cout << (editDist("gotas","afoga")) << endl;
    return 1;
}

/// TESTS ///
#include <gtest/gtest.h>

TEST(TP8_Ex1, EditDistTest) {
    EXPECT_EQ(4,editDist("gotas","afoga"));
}