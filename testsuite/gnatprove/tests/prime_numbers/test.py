from test_support import prove_all

contains_manual_proof = False


def replay():
    prove_all(level=3, procs=0, counterexample=False)


if __name__ == "__main__":
    prove_all(replay=True, counterexample=False)
