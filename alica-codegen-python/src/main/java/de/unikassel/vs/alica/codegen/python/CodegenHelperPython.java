package de.unikassel.vs.alica.codegen.python;

import de.unikassel.vs.alica.codegen.CodegenHelper;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;

public class CodegenHelperPython extends CodegenHelper {
    @Override
    public void createFolder(Path folder) {
        super.createFolder(folder);
        createInitFile(folder.toString());
    }

    private void createInitFile(String destinationDir) {
        File filePath = Paths.get(destinationDir, "__init__.py").toFile();
        if (filePath.exists()) {
            return;
        }
        writeSourceFile(filePath.toString(), "");
    }
}
