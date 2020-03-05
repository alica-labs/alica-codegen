package de.unikassel.vs.alica.codegen;

import de.unikassel.vs.alica.planDesigner.modelmanagement.ModelManager;

/**
 * This Codegenerator console application (re)generates all plans/behaviours and terminates afterwards.
 */
public class StandaloneCodegenerator {
    private static String sourceGenPath;
    private static String plansPath;
    private static String rolesPath;
    private static String tasksPath;

    private static void printUsage() {
        System.out.println("Usage: java -jar StandaloneCodegenerator <sourceGenPath> <plansPath> <rolesPath> <tasksPaths>");
        System.exit(-1);
    }

    private static void readCmdLineArgs(String[] args) {
        if (args.length < 4) {
            printUsage();
        }
        sourceGenPath = args[0];
        plansPath = args[1];
        rolesPath = args[2];
        tasksPath = args[3];
    }

    public static void main(String[] args) {
        readCmdLineArgs(args);

        ModelManager modelManager = new ModelManager();
        modelManager.setPlansPath(plansPath);
        modelManager.setTasksPath(tasksPath);
        modelManager.setRolesPath(rolesPath);
        modelManager.loadModelFromDisk();

        GeneratedSourcesManagerPython generatedSourcesManager = new GeneratedSourcesManagerPython();

        CodegeneratorPython codegenerator = new CodegeneratorPython(
                modelManager.getPlans(),
                modelManager.getBehaviours(),
                modelManager.getConditions(),
                sourceGenPath,
                generatedSourcesManager
        );
        codegenerator.generate();
    }
}
