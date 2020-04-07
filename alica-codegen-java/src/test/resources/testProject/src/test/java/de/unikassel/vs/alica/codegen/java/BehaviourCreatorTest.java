package de.unikassel.vs.alica.codegen.java;

import de.uniks.vs.alica.code.gen.creators.BehaviourCreator;
import de.uniks.vs.alica.code.gen.behaviours.TestfxBehaviour;
import de.uniks.vs.jalica.engine.BasicBehaviour;
import org.junit.Assert;
import org.junit.Test;

public class BehaviourCreatorTest {
    @Test
    public void testCreateExistingBehaviour() throws Exception {
        BehaviourCreator behaviourCreator = new BehaviourCreator();
        BasicBehaviour existingBehaviour = behaviourCreator.createBehaviour(1575724510639L, null);
        Assert.assertTrue(existingBehaviour instanceof TestfxBehaviour);
    }

    @Test()
    public void testCreateNotExistingBehaviour() throws Exception {
        BehaviourCreator behaviourCreator = new BehaviourCreator();
        BasicBehaviour notExistingBehaviour = behaviourCreator.createBehaviour(0L, null);
        Assert.assertNull(notExistingBehaviour);
    }
}
