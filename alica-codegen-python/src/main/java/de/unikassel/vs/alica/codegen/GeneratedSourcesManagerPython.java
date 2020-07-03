package de.unikassel.vs.alica.codegen;

import de.unikassel.vs.alica.planDesigner.alicamodel.AbstractPlan;
import de.unikassel.vs.alica.planDesigner.alicamodel.Behaviour;

import java.io.File;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

public class GeneratedSourcesManagerPython extends GeneratedSourcesManager {

    public List<File> getGeneratedFilesForBehaviour(Behaviour behaviour) {
        List<File> generatedFiles = new ArrayList<>();
        String path = trimFileFromPath(behaviour.getRelativeDirectory());
        String filename = behaviour.getName() + ".py";
        generatedFiles.add(Paths.get(getSourcePath(), path, filename).toFile());
        return generatedFiles;
    }

    public List<File> getGeneratedConditionFilesForPlan(AbstractPlan abstractPlan) {
        List<File> generatedFiles = new ArrayList<>();
        String path = trimFileFromPath(abstractPlan.getRelativeDirectory());
        String filename = abstractPlan.getName() + "_" + abstractPlan.getId() + ".py";
        generatedFiles.add(Paths.get(getSourcePath(), path, filename).toFile());
        return generatedFiles;
    }

    public List<File> getGeneratedConstraintFilesForPlan(AbstractPlan abstractPlan) {
        List<File> generatedFiles = new ArrayList<>();
        String path = trimFileFromPath(abstractPlan.getRelativeDirectory());
        String filename = abstractPlan.getName() + "_" + abstractPlan.getId() + "_constraints.py";
        generatedFiles.add(Paths.get(getSourcePath(), path, "constraints", filename).toFile());
        return generatedFiles;
    }

    public List<File> getGeneratedConstraintFilesForBehaviour(Behaviour behaviour) {
        List<File> generatedFiles = new ArrayList<>();
        String path = trimFileFromPath(behaviour.getRelativeDirectory());
        String filename = behaviour.getName() + "_" + behaviour.getId() + "_constraints.py";
        generatedFiles.add(Paths.get(getSourcePath(), path, "constraints", filename).toFile());
        return generatedFiles;
    }
}
