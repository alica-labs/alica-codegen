import de.unikassel.vs.alica.codegen.CodegeneratorCpp;
import de.unikassel.vs.alica.codegen.GeneratedSourcesManagerCpp;
import de.unikassel.vs.alica.planDesigner.alicamodel.*;
import org.junit.BeforeClass;
import org.junit.ClassRule;
import org.junit.Ignore;
import org.junit.Test;
import org.junit.rules.TemporaryFolder;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

public class CodegenCppTest {
    private static String tmpPath;

    @ClassRule
    public static TemporaryFolder tmpFolder = new TemporaryFolder();

    @BeforeClass
    public static void beforeClass() {
        tmpPath = tmpFolder.getRoot().getAbsolutePath();
    }

    private void generateCode() {
        // Generates java source code

        Plan plan = new Plan();
        plan.setMasterPlan(true);
        EntryPoint entryPoint = new EntryPoint();
        plan.addEntryPoint(entryPoint);
        State state = new State();
        TerminalState terminalState = new TerminalState();
        plan.addState(state);
        plan.addState(terminalState);
        Transition transition = new Transition();
        plan.addTransition(transition);
        plan.setDirty(false);
        plan.setRelativeDirectory("");
        plan.setId(1575724499793L);
        plan.setName("testfxPlan");

        List<Plan> plans = new ArrayList<>();
        plans.add(plan);

        Behaviour behaviour = new Behaviour();
        behaviour.setDirty(false);
        behaviour.setRelativeDirectory("");
        behaviour.setId(1575724510639L);
        behaviour.setName("testfxBehaviour");

        List<Behaviour> behaviours = new ArrayList<>();
        behaviours.add(behaviour);

        PreCondition preCondition = new PreCondition();
        preCondition.setEnabled(true);
        preCondition.setPluginName("DefaultPlugin");
        preCondition.setId(1575724578855L);
        preCondition.setName("Precondition1");
        plan.setPreCondition(preCondition);

        List<Condition> conditions = new ArrayList<>();
        conditions.add(preCondition);

        // generate code
        String genPath = tmpPath + File.separator + "src" + File.separator + "main" + File.separator + "java";
        GeneratedSourcesManagerCpp generatedSourcesManager = new GeneratedSourcesManagerCpp();
        generatedSourcesManager.setGenSrcPath(genPath);
        String clangFormatPath = "clang-format";
        CodegeneratorCpp codegenerator = new CodegeneratorCpp(
                plans,
                behaviours,
                conditions,
                clangFormatPath,
                genPath,
                generatedSourcesManager);
        codegenerator.generate();
    }

    @Ignore
    @Test
    public void testGeneratedCode() {
        generateCode();

        // TODO: NullPointerException at CodegeneratorCpp.java:78 - DefaultPlugin not set
        // TODO: Use test framework https://github.com/catchorg/Catch2 ?
    }
}
