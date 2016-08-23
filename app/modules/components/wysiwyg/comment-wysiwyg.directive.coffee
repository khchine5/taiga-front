CommentWysiwyg = (attachmentsFullService) ->
    link = ($scope, $el, $attrs) ->
        $scope.editableDescription = false

        $scope.saveComment = (description, cb) ->
            $scope.content = ''
            $scope.vm.type.comment = description
            $scope.vm.onAddComment({callback: cb})

        types = {
            userstories: "us",
            issues: "issue",
            tasks: "task"
        }

        uploadFile = (file, cb) ->
            return attachmentsFullService.addAttachment($scope.vm.projectId, $scope.vm.type.id, types[$scope.vm.type._name], file).then (result) ->
                cb(result.getIn(['file', 'name']), result.getIn(['file', 'url']))

        $scope.onChange = (markdown) ->
            $scope.vm.type.comment = markdown

        $scope.uploadFiles = (files, cb) ->
            for file in files
                uploadFile(file, cb)

        $scope.content = ''

        $scope.$watch "vm.type", (value) ->
            return if not value

            $scope.storageKey = "comment-" + value.project + "-" + value.id + "-" + value._name

    return {
        scope: true,
        link: link,
        template: """
            <div>
                <tg-wysiwyg
                    required
                    not-persist
                    placeholder='{{"COMMENTS.TYPE_NEW_COMMENT" | translate}}'
                    storage-key='storageKey'
                    content='content'
                    on-save='saveComment(text, cb)'
                    on-upload-file='uploadFiles(files, cb)'>
                </tg-wysiwyg>
            </div>
        """
    }

angular.module("taigaComponents")
    .directive("tgCommentWysiwyg", ["tgAttachmentsFullService", CommentWysiwyg])
