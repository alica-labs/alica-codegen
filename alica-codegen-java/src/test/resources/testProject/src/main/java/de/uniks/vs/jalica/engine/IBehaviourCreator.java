package de.uniks.vs.jalica.engine;

public interface IBehaviourCreator {
    BasicBehaviour createBehaviour(long behaviourId, Object context);
}
