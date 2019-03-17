#include <iostream>
#include <set>

int main() {
    std::cout << "---------------" << std::endl;
    std::set<int> a = {1000, 2000, 3000, 8};
    std::set<int> b;
    a.insert(100);
    std::cout << b.empty() << std::endl;
    std::cout << "a.max_size = " << a.max_size() << std::endl;
    std::cout << "a.count(100) = " << a.count(100) << std::endl;
    std::cout << "a.fing(100) = " << *a.find(100) << std::endl;
    //return an iterator pointing to the first element that is not less that key
    std::cout << "a.lower_bound(1000) = " << *a.lower_bound(1000) << std::endl;
    //return an iterator pointing to the first element that is greater that key
    std::cout << "a.upper_bound(1000) = " << *a.upper_bound(1000) << std::endl;
    //std::cout << "a.contain(100) = " << a.contains(100) << std::endl; //C++20
    if (a.empty()) {
        std::cout << "set a is empty" << std::endl;
    }
    else {
        std::cout << "a.size = " << a.size() << std::endl;
        std::cout << "a.begin = " << *a.begin() << std::endl;
        std::cout << "a.end = " << *a.end() << std::endl;
        //std::cout << "a.cbegin = " << *a.cbegin() << std::endl;
        //std::cout << "a.cend = " << *a.cend() << std::endl;
        std::cout << "in order" << std::endl;
        for (auto it = a.begin(); it != a.end(); it++) {
            std::cout << *it << std::endl;
        }
        std::cout << "reverse" << std::endl;
        for (auto it = a.rbegin(); it != a.rend(); it++) {
            std::cout << *it << std::endl;
        }
    }
    std::cout << "after erase" << std::endl;
    for (auto it = a.begin(); it != a.end(); it++) {
        if (*it % 200 == 0) {
            a.erase(it);
        }
    }
    //a.erase(a.begin(), a.end());
    a.erase(8);
    for (auto n : a) {
        std::cout << n << std::endl;
    }
    a.swap(b);
    for (auto n : b) {
        std::cout << n << std::endl;
    }
    for (auto n : a) {
        std::cout << n << std::endl;
    }
    a.clear();
    b.clear();
    std::cout << "---------------" << std::endl;
    return 0;
}
