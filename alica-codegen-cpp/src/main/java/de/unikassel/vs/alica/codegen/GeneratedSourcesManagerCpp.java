package de.unikassel.vs.alica.codegen;

import de.unikassel.vs.alica.planDesigner.alicamodel.AbstractPlan;
import de.unikassel.vs.alica.planDesigner.alicamodel.Behaviour;
import org.apache.commons.lang3.StringUtils;

import java.io.File;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

public class GeneratedSourcesManagerCpp extends GeneratedSourcesManager {

    @Override
    public String getSourcePath() {
        return Paths.get(sourcePath, "src").toString();
    }

    public String getHeaderPath() {
        return Paths.get(sourcePath, "include").toString();
    }

    public List<File> getGeneratedFilesForBehaviour(Behaviour behaviour) {
        List<File> generatedFiles = new ArrayList<>();
        String destinationPath = trimFileFromPath(behaviour.getRelativeDirectory());
        String nameId = StringUtils.capitalize(behaviour.getName()) + behaviour.getId();
        generatedFiles.add(Paths.get(getHeaderPath(), destinationPath, nameId + ".h").toFile());
        generatedFiles.add(Paths.get(getSourcePath(), destinationPath, nameId + ".cpp").toFile());
        return generatedFiles;
    }

    public List<File> getGeneratedConditionFilesForPlan(AbstractPlan abstractPlan) {
        List<File> generatedFiles = new ArrayList<>();
        String destinationPath = trimFileFromPath(abstractPlan.getRelativeDirectory());
        String nameId = StringUtils.capitalize(abstractPlan.getName()) + abstractPlan.getId();
        String headerFilename = nameId + ".h";
        String sourceFilename = nameId + ".cpp";
        generatedFiles.add(Paths.get(getHeaderPath(), destinationPath, headerFilename).toFile());
        generatedFiles.add(Paths.get(getSourcePath(), destinationPath, sourceFilename).toFile());
        return generatedFiles;
    }

    public List<File> getGeneratedConstraintFilesForPlan(AbstractPlan abstractPlan) {
        List<File> generatedFiles = new ArrayList<>();
        String destinationPath = trimFileFromPath(abstractPlan.getRelativeDirectory());
        String nameId = StringUtils.capitalize(abstractPlan.getName()) + abstractPlan.getId() + "Constraints";
        String constraintHeaderFileName = nameId + ".h";
        String constraintSourceFileName = nameId + ".cpp";
        generatedFiles.add(Paths.get(getHeaderPath(), destinationPath, "constraints", constraintHeaderFileName).toFile());
        generatedFiles.add(Paths.get(getSourcePath(), destinationPath, "constraints", constraintSourceFileName).toFile());
        return generatedFiles;
    }

    public List<File> getGeneratedConstraintFilesForBehaviour(Behaviour behaviour) {
        List<File> generatedFiles = new ArrayList<>();
        String destinationPath = trimFileFromPath(behaviour.getRelativeDirectory());
        String nameId = StringUtils.capitalize(behaviour.getName()) + behaviour.getId() + "Constraints";
        String constraintHeaderFileName = nameId + ".h";
        String constraintSourceFileName = nameId + ".cpp";
        generatedFiles.add(Paths.get(getHeaderPath(), destinationPath, "constraints", constraintHeaderFileName).toFile());
        generatedFiles.add(Paths.get(getSourcePath(), destinationPath, "constraints", constraintSourceFileName).toFile());
        return generatedFiles;
    }
}
