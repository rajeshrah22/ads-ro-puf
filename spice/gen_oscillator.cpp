//
#include <iostream>
#include <random>
#include <tuple>

auto main() ->  int{
    constexpr size_t total_inverters=12;
    std::random_device rd{};
    std::mt19937 rng{rd()};
    std::normal_distribution distribution{1.0, 0.05};

    auto in_range = [](auto x, auto mu, auto k)
    { return (mu-k) <= x && x <= (mu+k); };
    auto get_random = [&distribution, &rng, in_range](auto range){ double t;
    do{
    t = distribution(rng);
    }while(!in_range(t, 1, range));
    return t;
    };

    auto get_size_variations = [get_random]() {
    return std::make_tuple(get_random(0.15), get_random(0.15), get_random(0.15), get_random(0.15));
    };

    auto get_thickess_variations = [get_random]()  {
    return std::make_tuple(get_random(0.10), get_random(0.10));
    };

    std::cout <<"* ring oscillator\n.subckt ring_oscillator_5 en n12" << std::endl;

    std::cout <<"xNAND en n12 n0 nand2x1" << std::endl;

    for(size_t i=0; i < total_inverters; i++){
    auto [tplv, tpwv, tnln, tnwn] = get_size_variations();
    auto [tpotv, tnotv] = get_thickess_variations();
    std::cout
    <<"x" << (i+1) << " n" << i << " n" << (i+1)<< " inverter"
    << " tplv=" << tplv << " tpwv=" << tpwv
    << " tnln=" << tnln << " tnwn=" << tnwn
    << " tpotv=" << tpotv << " tnotv=" << tnotv
    << std::endl;
    }
    std::cout <<".ends\n" << std::endl;
}
